//= require jquery
//= require jquery.turbolinks
//= require twitter/bootstrap
//= require jquery_ujs

//= require wice_grid

//= require inspinia/plugins/metisMenu/jquery.metisMenu
//= require inspinia/plugins/slimscroll/jquery.slimscroll.min
//= require inspinia/plugins/flot/jquery.flot
//= require inspinia/plugins/flot/jquery.flot.tooltip.min
//= require inspinia/plugins/flot/jquery.flot.spline
//= require inspinia/plugins/flot/jquery.flot.resize
//= require inspinia/plugins/flot/jquery.flot.pie
//= require inspinia/plugins/peity/jquery.peity.min

//= require inspinia/plugins/switchery/switchery
//= require inspinia/plugins/gritter/jquery.gritter.min
//= require inspinia/plugins/easypiechart/jquery.easypiechart
//= require inspinia/plugins/sparkline/jquery.sparkline.min
//= require inspinia/plugins/chartJs/Chart.min
//= require inspinia/plugins/iCheck/icheck.min

//= require inspinia/inspinia
//= require auto_refresher

//= require nprogress
//= require nprogress-turbolinks

//= require turbolinks

$(document).ready(function() {

  // Switcher
  var elems = Array.prototype.slice.call(document.querySelectorAll('.js-switch'));
  elems.forEach(function(html) {
    var element = $(html);
    if (element.data('switchery') != true) {
      var switchery = new Switchery(html);
    }
  });

  // Checkbox style
  $('.i-checks').iCheck({
      checkboxClass: 'icheckbox_square-green',
      radioClass: 'iradio_square-green',
  });


});