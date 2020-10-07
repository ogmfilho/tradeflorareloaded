
const initCarousel = () => {
    
    $("#carousel-de-imagens").carousel();
    console.log(document.querySelector("#carousel-de-imagens"));

    $(".left").click(function(){
      $("#carousel-de-imagens").carousel('prev');
    });
    $(".right").click(function(){
      $("#carousel-de-imagens").carousel('next');
    });
    
};

export {initCarousel};