
var movie;

function connectWebViewJavascriptBridge(callback) {
    if (window.WebViewJavascriptBridge) {
        callback(WebViewJavascriptBridge)
    } else {
        document.addEventListener('WebViewJavascriptBridgeReady', function() {
            callback(WebViewJavascriptBridge)
         }, false)
    }
}

    connectWebViewJavascriptBridge(function(bridge) {
        var uniqueId = 1
        function log(message, data) {
            var log = document.getElementById('log')
            var el = document.createElement('div')
            el.className = 'logLine'
            el.innerHTML = uniqueId++ + '. ' + message + (data ? ':<br/>' + JSON.stringify(data) : '')
            if (log.children.length) { log.insertBefore(el, log.children[0]) }
            else { log.appendChild(el) }
        }
        bridge.init(function(message, responseCallback) {
            responseCallback(data)
        })

        bridge.callHandler('GetJsonFromObjc', {'id': '123456'}, function(response) {
                movie = JSON.parse(response)
                //log(movie.title)
                renderTemplate()
            })
    })


function renderTemplate () {
    renderMovieBriefSection();
    renderMovieDetailSection();
}

function renderMovieBriefSection () {
    var tplMoiveHeader = $("#Tpl-movie-header").text(),
        html = $(TemplateEngine(tplMoiveHeader, movie)),
        movieBriefSection = $("#movie-brief-section");
    movieBriefSection.append(html);
}

function renderMovieDetailSection () {
    var tplMoiveDetail = $("#Tpl-movie-detail-section").text(),
        html = $(TemplateEngine(tplMoiveDetail, movie)),
        detailSection = $("#movie-detail-section");
    detailSection.append(html);
}

function wish () {
        location.href = "doubanmovie://action/wish/5317291";
}

function collect () {
        location.href = "doubanmovie://action/collect/5317291";
}

function purchase () {
        location.href = "doubanmovie://action/purchase/5317291";
}

var TemplateEngine = function(html, data) {
    var re = /{{([\s\S]+?(?=}}))?}}/g,
        reExp = /(^( )?(if|for|else|switch|case|break|{|}))(.*)?/g,
        code = 'with(obj||{}){var r=[];\n',
        cursor = 0,
        match;

    var add = function(line, js) {
        js? (code += line.match(reExp) ? line + '\n' : 'r.push(' + line + ');\n') :
            (code += line != '' ? 'r.push("' + line.replace(/"/g, '\\"') + '");\n' : '');
        return add;
    }
    while (match = re.exec(html)) {
        add(html.slice(cursor, match.index))(match[1], true);
        cursor = match.index + match[0].length;
    }
    add(html.substr(cursor, html.length - cursor));
    code += 'return r.join("");}';
    return new Function('obj', code.replace(/[\r\t\n]/g, '')).call(null, data);
};

