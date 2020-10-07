// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

// Importacao do pacote de estilo Design System - GOV BRASIL:
//require("../../../vendor/assets/dist/js/dsgov")

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)


// ----------------------------------------------------
// Note(lewagon): ABOVE IS RAILS DEFAULT CONFIGURATION
// WRITE YOUR OWN JS STARTING FROM HERE 👇
// ----------------------------------------------------

// External imports
import "bootstrap";
import { initSelect2 } from '../plugins/init_select2';
import { initSelectmult } from '../plugins/init_selectmult';
//mini-mapa dinamico do show das areas: 
import { initBrToolTip } from '../plugins/init_brtooltip';
//nav-bar do gov:
import { initBrHeader } from '../plugins/init_brheader';
//mini-menu do avatar:
import { initBrNotification } from '../plugins/init_brnotification';
//footer do gov:
import { initFooter } from '../plugins/init_footer';

import { initMapbox } from '../plugins/init_mapbox';

document.addEventListener('turbolinks:load', () => {
  initMapbox();
  initSelect2();
  initSelectmult();
  initBrToolTip();
  initBrHeader();
  initBrNotification();
  initFooter();
})
