import { createRouter, createWebHistory } from "vue-router"
import useSessionStore from "../stores/SessionStore"

import Home from "../views/Home.vue"
import Chat from "../views/Chat.vue"

const authGuard = (_to, _from, next) => {
  const isLoggedIn = useSessionStore().isLoggedIn

  if (isLoggedIn) {
    next()
  } else {
    next({ name: "Home" })
  }
}

const routes = [
  {
    path: "/",
    name: "Home",
    component: Home
  },
  {
    path: "/chat",
    name: "Chat",
    component: Chat,
    beforeEnter: authGuard
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
