import { defineStore } from "pinia"

const API_URL = "http://localhost:3000"

const useSessionStore = defineStore("SessionStore", {
  state: () => ({
    authToken: null,
    user: {
      id: null,
      email: null
    },
    errors: []
  }),

  getters: {
    getAuthToken() {
      return this.authToken
    },

    getUserEmail() {
      return this.user.email
    },

    getUserId() {
      return this.user.id
    },

    getUserUsername() {
      return this.user.username
    },

    isLoggedIn() {
      const loggedOut = this.authToken === null || this.authToken === JSON.stringify(null)

      return !loggedOut
    }
  },

  actions: {
    registerUser(params) {
      return this.handleUserForm(`${API_URL}/users`, params)
    },

    loginUser(params) {
      return this.handleUserForm(`${API_URL}/users/sign_in`, params)
    },

    async handleUserForm(url, params) {
      try {
        const res = await fetch(url, {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ user: params })
        })

        if (!res.ok) {
          const error = await res.json()
          this.errors = error.message

          console.log(`An error occured: ${error.message}`) // eslint-disable-line no-console
          return false
        }

        this.authToken = res.headers.get("Authorization")
        localStorage.setItem("authToken", this.authToken)

        const data = await res.json()
        this.user = data.user

        return true
      } catch (error) {
        console.log(`An error occured: ${error}`) // eslint-disable-line no-console
        return false
      }
    },

    async loginUserWithToken(token) {
      try {
        const res = await fetch(`${API_URL}/member-data`, {
          headers: { Authorization: token }
        })

        if (!res.ok) {
          const error = await res.json()
          console.log(`An error occured while logging in: ${error.message}`) // eslint-disable-line no-console
          this.reset()
        } else {
          const data = await res.json()
          this.user = data.user
          this.authToken = localStorage.getItem("authToken")
        }
      } catch (error) {
        console.log(`An error occured while logging in: ${error}`) // eslint-disable-line no-console
      }
    },

    async logoutUser() {
      try {
        const res = await fetch(`${API_URL}/users/sign_out`, {
          method: "DELETE",
          headers: { Authorization: this.authToken }
        })

        if (!res.ok) {
          const error = await res.json()

          console.log(`An error occured while logging in: ${error.message}`) // eslint-disable-line no-console
        } else {
          this.reset()
        }
      } catch (error) {
        console.log(`An error occured while logging out: ${error}`) // eslint-disable-line no-console
      }
    },

    reset() {
      this.$reset()
      localStorage.removeItem("authToken")
    }
  }
})

export default useSessionStore
