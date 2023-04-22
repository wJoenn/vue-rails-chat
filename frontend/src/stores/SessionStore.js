import { defineStore } from "pinia"

const API_URL = "http://localhost:3000"

const useSessionStore = defineStore("SessionStore", {
  state: () => ({
    auth_token: null,
    user: {
      id: null,
      email: null,
      username: null
    }
  }),

  getters: {
    getAuthToken() {
      return this.auth_token
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
      const loggedOut = this.auth_token === null || this.auth_token === JSON.stringify(null)

      return !loggedOut
    }
  },

  actions: {
    async registerUser(payload) {
      const res = await fetch(`${API_URL}/users`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ payload })
      })

      if (!res.ok) {
        throw new Error(`HTTP error ${res.status}`);
      }

      console.log(res.json())
    },

    async loginUser(payload) {
      const res = await fetch(`${API_URL}/users/sign_in`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ payload })
      })

      if (!res.ok) {
        throw new Error(`HTTP error ${res.status}`);
      }
      console.log(res.json())
    },

    async loginUserWithToken(payload) {
      const res = await fetch(`${API_URL}/member-data`, {
        headers: { authorization: payload.auth_token }
      })

      console.log(res.json())
    },

    async logoutUser() {
      const res = await fetch(`${API_URL}/users/sign_out`, {
        method: "DELETE",
        headers: { authorization: this.auth_token }
      })

      if (!res.ok) {
        throw new Error(`HTTP error ${res.status}`);
      }
      console.log(res.json())
    }
  }
})

export default useSessionStore
