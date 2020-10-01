import mapboxgl from 'mapbox-gl';
import MapboxGeocoder from '@mapbox/mapbox-gl-geocoder';
import MapboxDraw from "@mapbox/mapbox-gl-draw"



const addMarkersToMap = (map, markers) => {
  markers.forEach((marker) => {
    const popup = new mapboxgl.Popup().setHTML(marker.infoWindow);
    new mapboxgl.Marker()
      .setLngLat([ marker.lng, marker.lat ])
      .setPopup(popup)
      .addTo(map);
  });
};

const fitMapToMarkers = (map, markers) => {
  const bounds = new mapboxgl.LngLatBounds();
  markers.forEach(marker => bounds.extend([ marker.lng, marker.lat ]));
  map.fitBounds(bounds, { padding: 70, maxZoom: 10, duration: 1 });
};

const initMapbox = () => {
  const mapElement = document.getElementById('map');
  if (mapElement) { // only build a map if there's a div#map to inject into
    mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;
    const attributes = {
      container: 'map',
      style: 'mapbox://styles/mapbox/satellite-streets-v11',
      center: [-40, -74.5],
      zoom: 12
    }

    const map = new mapboxgl.Map(attributes);

    const markers = JSON.parse(mapElement.dataset.markers);

    const draw = new MapboxDraw({
      displayControlsDefault: false,
      controls: {
        polygon: true,
        trash: true
      }
    });



   
    map.on('draw.create', updateArea);
    map.on('draw.delete', updateArea);
    map.on('draw.update', updateArea);

    map.on('mousemove', function (e) {
     document.getElementById('info').innerHTML =
     JSON.stringify(e.point) +
     '<br />' +
     JSON.stringify(e.lngLat.wrap());
    });
 
    function updateArea(e) {
      const data = draw.getAll();
      const answer = document.getElementById('calculated-area');
      if (data.features.length > 0) {
        const area = turf.area(data);
        // restrict to area to 2 decimal points
        const rounded_area = Math.round(area * 100) / 100;
        const area_ha = rounded_area / 10000
        answer.innerHTML = '<p><strong>' + 
        area_ha.toFixed(2) +
        '</strong></p><p>hectares</p>';
      } else {
        answer.innerHTML = '';
        if (e.type !== 'draw.delete')
            alert('Use the draw tools to draw a polygon!');
      }
      
    }


    addMarkersToMap(map, markers)

    fitMapToMarkers(map, markers);

    map.addControl(new MapboxGeocoder({ accessToken: mapboxgl.accessToken,
      mapboxgl: mapboxgl }));

    map.addControl(draw, 'top-left');


  }
};

// exportar a função
export { initMapbox };