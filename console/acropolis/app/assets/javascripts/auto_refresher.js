
(function() {

    function AutoRefresher (interval, page_url) {
        this.interval = interval;
        this.pageUrl = page_url;
        this.isEnabled = false;
        this.timer = null;
    }

    AutoRefresher.prototype = {
        constructor: AutoRefresher,
        refresh: function () {
            return $.ajax(this.pageUrl, {
                method: 'GET',
                dataType: 'script'
            });
        },
        stop: function () {
            if (this.timer !== null) {
                clearInterval(this.timer);
                this.isEnabled = false;
            }
            return console.log('Refresher was stopped');
        },
        start: function () {
            this.timer = setInterval(this.refresh, this.interval * 1000);
            this.isEnabled = true;
            return console.log('Refresher was started');
        }
    }

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

    if ($('#trading-account-show-page-content').length) {
      var trading_account_id = $('#trading-account-id').text();
      var autoRefresher2 = setInterval(function() {
        $.ajax('/trading_accounts/' + trading_account_id, {
                method: 'GET',
                dataType: 'script'
            });
        }, 3 * 1000);


        $(document).one('page:change', function() {
            clearInterval(autoRefresher2);
          });
    }
  });

}).call(this);