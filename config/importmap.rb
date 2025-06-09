# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "timeago.js" # @4.0.2
pin "timeago.js/lib/lang/zh_CN", to: "timeago.js--lib--lang--zh_CN.js" # @4.0.2
