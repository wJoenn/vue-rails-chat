import { createApp } from "vue"
import "./assets/stylesheets/style.scss"
import router from "./router/router"
import App from "./App.vue"

createApp(App).use(router).mount("#app")
