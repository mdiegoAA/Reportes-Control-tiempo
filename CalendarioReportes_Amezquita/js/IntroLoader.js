$(document).ready(function () {

    animacion();

});

function animacion() {
  
    $("#element").introLoader();
}

function pararAnimacion() {
    var loader = $('#element').data('introLoader');
    loader.stop();

}
