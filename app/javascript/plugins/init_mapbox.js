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

const fitMapToPolygon = (map, boundpoly) => {
  map.fitBounds(boundpoly, {padding: {top: 50, bottom:50, left: 50, right: 50}});
};

const loadPolygon = (map, polygon) => {
  map.on('load', function () {
          map.addSource('maine', {
            'type': 'geojson',
            'data': {
              'type': 'Feature',
              'geometry': {
                'type': 'Polygon',
                'coordinates': [polygon]
              }
            }
           });
          map.addLayer({
            'id': 'maine',
            'type': 'fill',
            'source': 'maine',
            'layout': {},
            'paint': {
              'fill-color': '#088',
              'fill-opacity': 0.8,
              'fill-outline-color': '#088'
            }
          });
        });
}

const loadPolygonEdit = (map, polygon) => {
  map.on('load', function () {
          map.addSource('maine', {
            'type': 'geojson',
            'data': {
              'type': 'Feature',
              'geometry': {
                'type': 'Polygon',
                'coordinates': [polygon]
              }
            }
           });
          map.addLayer({
            'id': 'maine',
            'type': 'fill',
            'source': 'maine',
            'layout': {},
            'paint': {
              'fill-color': 'red',
              'fill-opacity': 0.8,
              'fill-outline-color': 'red'
            }
          });
        });
}

const drawPolygon = (map, draw) => {
  map.addControl(draw, 'top-left');
         
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

              const extension = document.getElementById('area_extension');
              extension.value = area_ha.toFixed(2);
              answer.innerHTML = '<p><strong>' + 
              area_ha.toFixed(2) +
              '</strong></p><p>hectares</p>';
            } else {
              answer.innerHTML = '';
              if (e.type !== 'draw.delete')
                  alert('Use the draw tools to draw a polygon!');
            }

            const userPolygon = data.features[0].geometry.coordinates;
            const areaCoordinates = document.getElementById('area_coordinates');
            areaCoordinates.value = userPolygon.toString();

            const centroid = turf.centroid(data);
            const usercentroid = centroid.geometry.coordinates;
            const centroidlat = document.getElementById('area_latitude');
            centroidlat.value = usercentroid[1].toFixed(2);
            const centroidlong = document.getElementById('area_longitude');
            centroidlong.value = usercentroid[0].toFixed(2);
          }
}

const initMapbox = () => {
  const mapElement = document.getElementById('map');
  if (mapElement) { // only build a map if there's a div#map to inject into
    mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;
    const attributes = {
      container: 'map',
      style: 'mapbox://styles/mapbox/satellite-streets-v11',
      center: [-47, -15],
      zoom: 4
    }

    const map = new mapboxgl.Map(attributes);


    map.addControl(new MapboxGeocoder({ accessToken: mapboxgl.accessToken,
    mapboxgl: mapboxgl }));


    const title = document.querySelector('title');
    
   


      if (title.innerText.toLowerCase() === 'Nova Área | TradeFlora'.toLowerCase()){
         const draw = new MapboxDraw({
          displayControlsDefault: false,
          controls: {
          polygon: true,
          trash: true
          }
        });
        drawPolygon(map, draw);
      }

      if (title.innerText.toLowerCase() === 'Editar Área | TradeFlora'.toLowerCase()){
        const polygon = JSON.parse(mapElement.dataset.polygon);
        const boundpoly = JSON.parse(mapElement.dataset.boundpoly);
        const draw = new MapboxDraw({
          displayControlsDefault: false,
          controls: {
          polygon: true,
          trash: true
          }
        });
        fitMapToPolygon(map, boundpoly);
        loadPolygonEdit(map, polygon);
        drawPolygon(map, draw);
      }

      if (title.innerText.toLowerCase() === 'Todas as áreas | TradeFlora'.toLowerCase()){
        const markers = JSON.parse(mapElement.dataset.markers);
        addMarkersToMap(map, markers);
        fitMapToMarkers(map, markers);
      }

      if (title.innerText.toLowerCase() === 'Ver Área | TradeFlora'.toLowerCase()){
        const polygon = JSON.parse(mapElement.dataset.polygon);
        const boundpoly = JSON.parse(mapElement.dataset.boundpoly);
        fitMapToPolygon(map, boundpoly);
        loadPolygon(map, polygon);
        
      }
  }
};

// exportar a função
export { initMapbox };