class AreaSearch < ApplicationRecord

  def pesquisa
    areas = Area.all
    areas = areas.search_by_area_user_or_basin(keywords) if keywords.present?
    areas = areas.search_by_state(state_id) if state_id.present?

    areas = areas.search_by_city(city_id) if city_id.present?
    areas = areas.search_by_basin(basin_id) if basin_id.present?
    
    areas = areas.where("extension >= ?", min_extension ) if min_extension.present?
    areas = areas.where("extension <= ?", max_extension ) if max_extension.present?
  
    return areas
  end
end
