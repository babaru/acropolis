
(function() {

  $(function() {
    if ($('#monitoring-wrapper').length) {
      var autoRefresher1 = setInterval(function() {
        $.ajax('/risk_monitor', {
                method: 'GET',
                dataType: 'script'
            });
        }, 3 * 1000);


        $(document).one('page:change', function() {
            clearInterval(autoRefresher1);
          });
    }

    // if ($('#trading-account-show-page-content').length) {
    //   var trading_account_id = $('#trading-account-id').text();
    //   var autoRefresher2 = setInterval(function() {
    //     $.ajax('/trading_accounts/' + trading_account_id, {
    //             method: 'GET',
    //             dataType: 'script'
    //         });
    //     }, 3 * 1000);


    //     $(document).one('page:change', function() {
    //         clearInterval(autoRefresher2);
    //       });
    // }
  });

}).call(this);