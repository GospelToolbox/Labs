require 'json'
require 'oauth2'
require 'pco_api'
require 'json-api-vanilla'

class Api::Teamschedule::V1::ScheduleController < ApiController
  TOKEN_EXPIRATION_PADDING = 300

  def show
    org_schedule = Apps::TeamSchedule::Schedule.find_by(organization_id: params[:organization_id]) ||
                   Apps::TeamSchedule::Schedule.create(organization_id: params[:organization_id])

    render json: org_schedule.schedule
  end

  def refresh
    schedule = {
      service_types: {},
      service_type_teams: {},
      records: {},
      schedule_dates: Set.new,
      team_positions: {},
      team_names: {}
    }

    service_types = JSON::Api::Vanilla.build(api.services.v2.service_types.get)

    service_types.data.each do |service_type|
      # Set properties for our schedule cache
      schedule[:service_types][service_type.id] = service_type.name
      schedule[:service_type_teams][service_type.id] = Set.new
      schedule[:records][service_type.id] = {}

      # Load the plans for this service type
      service_type_endpoint = api.services.v2.service_types[service_type.id.to_i]
      plans = JSON::Api::Vanilla.build(service_type_endpoint.plans.get(filter: 'future'))

      plans.data.each do |plan|
        next if plan.last_time_at.nil?

        plan_date = Date.parse(plan.last_time_at).to_s

        schedule[:schedule_dates].add(plan_date)

        # Load the people for this plan
        plan_endpoint = service_type_endpoint.plans[plan.id.to_i]
        plan_people = JSON::Api::Vanilla.build(plan_endpoint.team_members.get(include: %w[team person]))

        plan_people.data.each do |person|
          team = person.team

          unless schedule[:records][service_type.id].key?(team.id)
            schedule[:records][service_type.id][team.id] = {}
          end

          schedule[:team_names][team.id] = team.name
          schedule[:service_type_teams][service_type.id].add(team.id)

          unless schedule[:team_positions].key?(team.id)
            schedule[:team_positions][team.id] = Set.new
          end

          position = person.team_position_name || '(Other)'

          unless schedule[:records][service_type.id][team.id].key?(position)
            schedule[:records][service_type.id][team.id][position] = {}
          end

          schedule[:team_positions][team.id].add(position)

          unless schedule[:records][service_type.id][team.id][position].key?(plan_date)
            schedule[:records][service_type.id][team.id][position][plan_date] = Set.new
          end

          schedule[:records][service_type.id][team.id][position][plan_date].add(
            name: person.name,
            status: person.status,
            notification_sent: !person.notification_sent_at.nil?
          )
        end
      end
    end

    # Cache schedule
    org_schedule = Apps::TeamSchedule::Schedule.find_by(organization_id: params[:organization_id])
    org_schedule ||= Apps::TeamSchedule::Schedule.create(organization_id: params[:organization_id])

    org_schedule.schedule = schedule.to_json
    org_schedule.last_updated = Time.now

    org_schedule.save
  end

  private

  def api
    PCO::API.new(oauth_access_token: token.token)
  end

  def token
    @token_container ||= PlanningCenterToken.find_by(organization_id: params[:organization_id])
    return if @token_container.nil?

    token_hash = JSON.parse(@token_container.token)
    token_hash['access_token']

    token = OAuth2::AccessToken.from_hash(client, token_hash.dup)

    if token.expires? && (token.expires_at < Time.now.to_i + TOKEN_EXPIRATION_PADDING) && token.refresh_token
      token = token.refresh!
      @token_container.token = token.to_json
      @token_container.save
    end

    token
  end

  def client
    OAuth2::Client.new(
      ENV['pco_client_id'],
      ENV['pco_secret'],
      site: 'https://api.planningcenteronline.com'
    )
 end
end
