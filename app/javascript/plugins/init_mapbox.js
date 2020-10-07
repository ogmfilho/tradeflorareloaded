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
    map.addSource('polygon', {
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
      'id': 'polygon',
      'type': 'fill',
      'source': 'polygon',
      'layout': {},
      'paint': {
        'fill-color': '#088',
        'fill-opacity': 0.8,
        'fill-outline-color': '#088'
      }
    });

    slider.addEventListener('input', function (e) {
      map.setPaintProperty(
        'polygon',
        'fill-opacity',
        parseInt(e.target.value, 10) / 100
        );
      sliderValue.textContent = e.target.value + '%';
    });
  });
}

const loadPolygonEdit = (map, polygon) => {
  map.on('load', function () {
    map.addSource('polygon', {
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
      'id': 'polygon',
      'type': 'fill',
      'source': 'polygon',
      'layout': {},
      'paint': {
        'fill-color': 'red',
        'fill-opacity': 0.8,
        'fill-outline-color': 'red'
      }
    });
    slider.addEventListener('input', function (e) {
      map.setPaintProperty(
        'polygon',
        'fill-opacity',
        parseInt(e.target.value, 10) / 100
        );
    });
  });
}

const drawPolygon = (map, draw) => {
  map.addControl(draw, 'bottom-left');
    map.on('draw.create', updateArea);
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
         
    map.on('draw.delete', function () {
      const areaCoordinates = document.getElementById('area_coordinates');
      areaCoordinates.value = null;
      const areaExtension = document.getElementById('area_extension');
      areaExtension.value = null;
      const areaLongitude = document.getElementById('area_longitude');
      areaLongitude.value = null;
      const areaLatitude = document.getElementById('area_latitude');
      areaLatitude.value = null;
      const areaDisplay = document.getElementById('calculated-area').querySelector('p');
      areaDisplay.innerText = null;
      console.log('deleted');
    });
    
    const userPolygon = data.features[0].geometry.coordinates;
    const areaCoordinates = document.getElementById('area_coordinates');
    areaCoordinates.value = userPolygon.toString();

    const centroid = turf.centroid(data);
    const usercentroid = centroid.geometry.coordinates;
    const centroidlat = document.getElementById('area_latitude');
    centroidlat.value = usercentroid[1];
    const centroidlong = document.getElementById('area_longitude');
    centroidlong.value = usercentroid[0];
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
    //adicionando controle de navegacao
    map.addControl(new mapboxgl.NavigationControl());

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
    const slider = document.getElementById('slider');
    const sliderValue = document.getElementById('slider-value');
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
    const slider = document.getElementById('slider');
    const sliderValue = document.getElementById('slider-value');
    fitMapToPolygon(map, boundpoly);
    loadPolygon(map, polygon);
    
  }
  }
};

// exportar a função
export { initMapbox };