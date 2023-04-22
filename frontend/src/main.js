import { createApp } from "vue"
import { createPinia } from "pinia"
import router from "./router/router"

import App from "./App.vue"
import useSessionStore from "./stores/SessionStore"

import "./assets/stylesheets/style.scss"

const app = createApp(App)
const pinia = createPinia()

// Load JWT from local storage on refresh

const authToken = localStorage.getItem("auth_token")
const authTokenExists = authToken !== "undefined" && authToken !== null

if (authTokenExists) {
  await useSessionStore.loginUserWithToken(authToken)
}

app.use(router).use(pinia).mount("#app")
