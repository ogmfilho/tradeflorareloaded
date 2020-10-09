import $ from 'jquery';
import 'select2';


const initSelect2 = () => {
  $('#select2').select2();  
};



const updateMunicipioInput = (municipio) => {

 document.querySelectorAll("optgroup > option").forEach((elemento, index) => {
   if (elemento.label === municipio){
     document.getElementById("area_city_id").options[index+1].selected = true;
     
    }
  });
  
};



export { initSelect2, updateMunicipioInput};
