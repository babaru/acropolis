function AutoRefresher (interval, page_url) {
    this.interval = interval;
    this.pageUrl = page_url;
    this.isEnabled = false;
    this.timer = null;
}


AutoRefresher.prototype = {
    constructor: AutoRefresher,
    refresh: function () {
        $.ajax({
            url: this.pageUrl,
            method: 'GET',
            dataType: 'script'
        });
    },
    stop: function () {
        if (this.timer != null) {
            clearInterval(this.timer);
            this.isEnabled = false;
        }
    },
    start: function () {
        this.timer = setInterval(this.refresh, this.interval * 1000);
        this.isEnabled = true;
    },
    toggle: function () {
        if (this.isEnabled == true) {
            this.stop();
        } else {
            this.start();
        }
    }
}

