require_dependency "set_live/application_controller"

require_dependency "pco/source_api"
require_dependency "pco/synchronizer"

module SetLive
  class SetsController < ApplicationController
    ORG_ID = 1

    def index
      @service_types = PCO::ServiceType.all
    end

    def show
      @plan = PCO::Plan.find(params[:id])
    end

    def sync
      @plan = PCO::Plan.find(params[:set_id])

      ids_to_delete = @plan.pco_plan_items.map(&:pco_id).to_a
      api.plan_items(@plan.pco_service_type.pco_id, @plan.pco_id).each do |item|

        # This item is still in the plan, so don't delete it
        ids_to_delete.delete(item['id'])

        rel = item['relationships']

        song_id = rel.dig('song', 'data', 'id')
        if song_id
          song_model = sync_song(song_id)

          arrangement_id = rel.dig('arrangement', 'data', 'id')
          if arrangement_id
            arrangment_model = sync_arrangement(song_model, arrangement_id)

            key_id = rel.dig('key', 'data', 'id')
            sync_key(song_model, arrangment_model, key_id) if key_id
          end
        end

        synchronizer.save_plan_item(@plan.id, item)
      end

      # Delete any items that are no longer in the plan
      ids_to_delete.each do |id|
        puts "Deleting '#{id}'..."
        PCO::PlanItem.where(pco_id: id).destroy_all
      end
    end

    def enumerate_plan_items(plan)
      enumerate_paged_response do |offset,per_page|
        api.services.v2.service_types[plan.pco_service_type.pco_id.to_i].plans[plan.pco_id.to_i].items.get(offset: offset, per_page: per_page)
      end
    end

    protected

    def sync_song(song_id)
      song = api.song(song_id)
      synchronizer.save_song(song)
    end

    def sync_arrangement(song_model, arrangement_id)
      arrangement = api.song_arrangement(song_model.pco_id, arrangement_id)
      synchronizer.save_arrangement(song_model.id, arrangement)
    end

    def sync_key(song_model, arrangment_model, key_id)
      key = api.song_arrangement_key(song_model.pco_id, arrangment_model.pco_id, key_id)
      synchronizer.save_key(arrangment_model.id, key)
    end

    def synchronizer
      @synchronizer ||= PCO::Synchronizer.new(ORG_ID)
    end

    def api
      PCO::SourceApi.new(ORG_ID)
    end  
  end
end
