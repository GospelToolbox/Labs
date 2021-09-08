require_dependency "pco/application_controller"

require_dependency "pco/source_api"
require_dependency "pco/synchronizer"

module PCO
  class SyncController < ApplicationController

    def sync_songs
      songs = api.songs.map { |song| synchronizer.save_song(song) }
      render :json => { song_count: songs.length }
    end

    def sync_song_tags
      tags_count = synced_songs.flat_map do |song|
        api.song_tags(song.pco_id.to_i)
           .map do |tag|
            tag_model = synchronizer.save_song_tag(tag)
            song.pco_tags << tag_model unless song.pco_tags.find_by(id: tag_model.id)
            song.save
            tag_model
          end
      end.length

      render :json => { tags_count: tags_count }
    end

    def sync_arrangements
      arrangements_count = synced_songs.flat_map do |song|
        api.song_arrangements(song.pco_id.to_i)
           .map { |arrangement| synchronizer.save_arrangement(song.id, arrangement) }
      end.length

      render :json => { arrangements_count: arrangements_count }
    end

    def sync_keys
      keys_count = synced_arrangements.flat_map do |arrangement|
        api.song_arrangement_keys(arrangement.pco_song.pco_id, arrangement.pco_id)
           .map { |key| synchronizer.save_key(arrangement.id, key) }
      end.length

      render :json => { keys_count: keys_count }
    end

    def sync_service_types
      service_types = api.service_types.each do |service_type|
        synchronizer.save_service_type(service_type)
      end

      render :json => { service_type_count: service_types.length }
    end

    def sync_plans
      plans_count = synced_service_types.flat_map do |service_type|
        api.plans(service_type.pco_id.to_i)
           .each { |plan| synchronizer.save_plan(service_type.id, plan) }
      end.length

      render :json => { plans_count: plans_count }
    end

    def sync_plan_items
      count = 0
      synced_future_plans.flat_map do |plan|  

        #next if plan.date < Date.today

        items = api.plan_items(plan.pco_service_type.pco_id.to_i, plan.pco_id.to_i)
        count += items.length

        ids_to_delete = plan.pco_plan_items.map(&:pco_id).to_a
        
        items.each do |item|
          synchronizer.save_plan_item(plan.id, item)

          # This item is still in the plan, so don't delete it
          ids_to_delete.delete(item['id'])
        end

        # Delete any items that are no longer in the plan
        ids_to_delete.each do |id|
          puts "Deleting plan item: #{id}"
          PCO::PlanItem.where(pco_id: id).destroy_all
        end
      end

      render :json => { items_count: count }
    end

    protected

    def synced_songs
      PCO::Song.where(organization_id: params[:organization_id])
    end

    def synced_arrangements
      PCO::Arrangement.where(organization_id: params[:organization_id])
    end

    def synced_service_types
      PCO::ServiceType.where(organization_id: params[:organization_id])
    end

    def synced_future_plans
      PCO::Plan.where(organization_id: params[:organization_id])
               .where('date >= ?', 1.year.ago)
    end
    
    def synchronizer
      @synchronizer ||= PCO::Synchronizer.new(params[:organization_id])
    end

    def api
      PCO::SourceApi.new(params[:organization_id])
    end  
  end
end
