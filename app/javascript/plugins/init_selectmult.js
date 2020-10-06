import $ from 'jquery';
import 'select2';


const initSelectmult = () => {
  $('.selectmult').select2({
    multiple: true,
  });
};

export { initSelectmult };
