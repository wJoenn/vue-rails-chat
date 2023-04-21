import { createApp } from "vue"
import { createPinia } from "pinia"
import router from "./router/router"

import "./assets/stylesheets/style.scss"
import App from "./App.vue"

const app = createApp(App)
const pinia = createPinia()

app.use(router).use(pinia).mount("#app")
