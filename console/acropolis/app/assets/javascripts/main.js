String.prototype.repeat = function (num) {
  'main strict';
  return new Array(num + 1).join(this);
};

(function ($) {
  'main strict';

  $(function () {

    // $('.pagination_status').addClass('label label-default');
    $('ul.pagination').addClass('pagination-plain pull-right').removeClass('pagination');
    $('div.pagination').removeClass('pagination');

  });
}(jQuery));