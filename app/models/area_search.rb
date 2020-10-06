class AreaSearch < ApplicationRecord
  
  

  def pesquisa
    @areas_after_states = []
    @areas_after_cities = []
    @areas_after_basins = []
    @areas = Area.all
    @areas = @areas.search_by_area_user_or_basin(keywords) if keywords.present?
    
    states_id.reject!(&:empty?)
    if states_id.present? && !@areas.empty?
      states_id.each { |state_id| @areas_after_states << @areas.search_by_state(state_id) }
      @areas = @areas_after_states.flatten
    end
    
    cities_id.reject!(&:empty?)
    if cities_id.present? && !@areas.empty?
      if !@areas_after_states.flatten.empty?
        cities_id.each do |city_id|
          unless @areas_after_states.flatten.include?(city_id)
            
            @areas = []
            return @areas
          end
        end
      end
      cities_id.each { |city_id| @areas_after_cities << @areas.search_by_city(city_id) }
      
      @areas =  @areas_after_cities.flatten
    end
    
    basins_id.reject!(&:empty?)
    if basins_id.present? && !@areas.empty?
      basins_id.each {|basin_id| @areas_after_basins << @areas.search_by_basin(basin_id) }
      @areas = @areas_after_basins.flatten
    end
    
    if !@areas.empty? && min_extension.present?
      @areas = @areas.where("extension >= ?", min_extension ) 
    end

    if !@areas.empty? && max_extension.present?
      @areas = @areas.where("extension <= ?", max_extension )
    end
    
    return @areas
  end

  def plural(number, word)
    if number> 1
      return "Algum dos #{number} #{word}s:" unless word.include?(" ")
      return "Alguma das #{number} #{word.split.map!{|x|x+"s"}.join(" ")}:" if word.include?(" ")
    end
    return "A #{word}:" if word.include?(" ")
    
    "O #{word}:"
  end 
end
