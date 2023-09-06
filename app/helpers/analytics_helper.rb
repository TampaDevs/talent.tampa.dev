module AnalyticsHelper
  def segment_analytics_tag
    if Rails.env.production?
      javascript_tag do
        <<-JS.html_safe
        !function(){var analytics=window.analytics=window.analytics||[];if(!analytics.initialize)if(analytics.invoked)window.console&&console.error&&console.error("Segment snippet included twice.");else{analytics.invoked=!0;analytics.methods=["trackSubmit","trackClick","trackLink","trackForm","pageview","identify","reset","group","track","ready","alias","debug","page","once","off","on","addSourceMiddleware","addIntegrationMiddleware","setAnonymousId","addDestinationMiddleware"];analytics.factory=function(e){return function(){if(window.analytics.initialized)return window.analytics[e].apply(window.analytics,arguments);var i=Array.prototype.slice.call(arguments);i.unshift(e);analytics.push(i);return analytics}};for(var i=0;i<analytics.methods.length;i++){var key=analytics.methods[i];analytics[key]=analytics.factory(key)}analytics.load=function(key,i){var t=document.createElement("script");t.type="text/javascript";t.async=!0;t.src="https://cdn.segment.com/analytics.js/v1/" + key + "/analytics.min.js";var n=document.getElementsByTagName("script")[0];n.parentNode.insertBefore(t,n);analytics._loadOptions=i};analytics._writeKey="J9KwHw1TSixl07WeR3ZkoHlHVLKDBfdf";;analytics.SNIPPET_VERSION="4.16.1";
        analytics.load("J9KwHw1TSixl07WeR3ZkoHlHVLKDBfdf");
        analytics.page();
        analytics.setAnonymousId("#{cookies[:uuid]}");
        }}();
        JS
      end
    else
      javascript_tag do
        <<-JS.html_safe
        !function(){var analytics=window.analytics=window.analytics||[];if(!analytics.initialize)if(analytics.invoked)window.console&&console.error&&console.error("Segment snippet included twice.");else{analytics.invoked=!0;analytics.methods=["trackSubmit","trackClick","trackLink","trackForm","pageview","identify","reset","group","track","ready","alias","debug","page","once","off","on","addSourceMiddleware","addIntegrationMiddleware","setAnonymousId","addDestinationMiddleware"];analytics.factory=function(e){return function(){if(window.analytics.initialized)return window.analytics[e].apply(window.analytics,arguments);var i=Array.prototype.slice.call(arguments);i.unshift(e);analytics.push(i);return analytics}};for(var i=0;i<analytics.methods.length;i++){var key=analytics.methods[i];analytics[key]=analytics.factory(key)}analytics.load=function(key,i){var t=document.createElement("script");t.type="text/javascript";t.async=!0;t.src="https://cdn.segment.com/analytics.js/v1/" + key + "/analytics.min.js";var n=document.getElementsByTagName("script")[0];n.parentNode.insertBefore(t,n);analytics._loadOptions=i};analytics._writeKey="PO60GSoD811FoEE2PD9FoMUHMcX5NXt5";;analytics.SNIPPET_VERSION="4.16.1";
        analytics.load("PO60GSoD811FoEE2PD9FoMUHMcX5NXt5");
        analytics.page();
        analytics.setAnonymousId("#{cookies[:uuid]}");
        }}();
        JS
      end
    end
  end

  def cloudflare_analytics_tag
    if Rails.env.production?
      "<script defer src='https://static.cloudflareinsights.com/beacon.min.js' data-cf-beacon='{\"token\": \"4352fe465c8e4236868952c7af6fb82a\"}'></script>".html_safe
    end
  end

  def gtm_tag
    if Rails.env.production?
      javascript_tag do
        <<-JS.html_safe
        (function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
        new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
        j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
        'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
        })(window,document,'script','dataLayer','GTM-MRVDHQWS');
        JS
      end
    end
  end

  def gtm_tag_noscript
    if Rails.env.production?
      "<script defer src='https://static.cloudflareinsights.com/beacon.min.js' data-cf-beacon='{\"token\": \"4352fe465c8e4236868952c7af6fb82a\"}'></script>".html_safe
    end
  end
end
