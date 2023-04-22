<template>
  <div id="home">
    <h1>Hello {{ sessionStore.getUserEmail }}</h1>

    <div>
      <a href="https://vitejs.dev" target="_blank">
        <img src="../assets/images/vite.svg" class="logo" alt="Vite logo">
      </a>

      <a href="https://vuejs.org/" target="_blank">
        <img src="../assets/images/vue.svg" class="logo vue" alt="Vue logo">
      </a>

      <a href="https://pinia.vuejs.org/" target="_blank">
        <img src="../assets/images/pinia.svg" class="logo pinia" alt="Vue logo">
      </a>
    </div>

    <HelloWorld msg="Vite + Vue" />

    <button @click="sessionStore.logoutUser()">Log out</button>

    <div>
      <h2>Sign In</h2>
      <form @submit.prevent="signIn">
        <input v-model="signInEmail" type="text" placeholder="email">
        <input v-model="signInPassword" type="password" placeholder="password">
        <button>Sign in</button>
      </form>

      <h2>Sign Up</h2>
      <form @submit.prevent="signUp">
        <input v-model="signUpEmail" type="text" placeholder="email">
        <input v-model="signUpPassword" type="password" placeholder="password">
        <button>Sign up</button>
      </form>
    </div>
  </div>
</template>

<script setup>
  import { ref } from "vue"
  import HelloWorld from "../components/HelloWorld.vue"
  import useSessionStore from "../stores/SessionStore"

  const sessionStore = useSessionStore()
  const signInEmail = ref("")
  const signInPassword = ref("")
  const signUpEmail = ref("")
  const signUpPassword = ref("")

  const resetRef = () => {
    signInEmail.value = ""
    signInPassword.value = ""
    signUpEmail.value = ""
    signUpPassword.value = ""
  }

  const signIn = async () => {
    const params = { email: signInEmail.value, password: signInPassword.value }

    const isSignedIn = await sessionStore.loginUser(params)
    if (isSignedIn) resetRef()
  }

  const signUp = async () => {
    const params = { email: signUpEmail.value, password: signUpPassword.value }

    const isRegistered = await sessionStore.registerUser(params)
    if (isRegistered) resetRef()
  }
</script>

<style lang="scss" scoped>
  .logo {
    height: 6em;
    padding: 1.5em;
    transition: filter 0.3s ease;

    &:hover {
      filter: drop-shadow(0 0 2em #646cffaa);
    }

    &.pinia:hover {
      filter: drop-shadow(0 0 2em #ffe368aa);
    }

    &.vue:hover {
      filter: drop-shadow(0 0 2em #42b883aa);
    }
  }
</style>
