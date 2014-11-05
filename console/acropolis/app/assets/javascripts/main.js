String.prototype.repeat = function (num) {
  'main strict';
  return new Array(num + 1).join(this);
};

(function ($) {
  'main strict';

  $(function () {

    $('.pagination_status').hide();

  });
}(jQuery));