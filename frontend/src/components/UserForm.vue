<template>
  <div id="user-form">
    <h2>V•O•R•P</h2>
    <div v-if="signingIn" class="sign-in">
      <form @submit.prevent="signIn">
        <div>
          <label for="email">Email</label>
          <input v-model="signInEmail" type="text" placeholder="Please enter your email" name="email">
        </div>

        <div>
          <label for="password">Password</label>
          <input v-model="signInPassword" type="password" placeholder="Please enter your password" name="password">
        </div>

        <button>Sign in</button>
      </form>

      <p>No account ? <span @click="signingIn = false">Sign up</span></p>
    </div>

    <div v-else class="sign-up">
      <form @submit.prevent="signUp">
        <div>
          <label for="email">Email</label>
          <input v-model="signUpEmail" type="text" placeholder="Please enter your email" name="email">
        </div>

        <div>
          <label for="password">Password</label>

          <div v-if="isHidden" class="password">
            <input v-model="signUpPassword" type="password" placeholder="Please enter your password" name="password">
            <FontAwesomeIcon icon="fa-solid fa-eye" @click="toggleHidden" />
          </div>

          <div v-else class="password">
            <input v-model="signUpPassword" type="text" placeholder="Please enter your password" name="password">
            <FontAwesomeIcon icon="fa-solid fa-eye-slash" @click="toggleHidden" />
          </div>
        </div>

        <button>Sign up</button>
      </form>

      <p>Already registered ? <span @click="signingIn = true">Sign in</span></p>
    </div>
  </div>
</template>

<script setup>
  import { ref } from "vue"
  import useSessionStore from "../stores/SessionStore"

  const sessionStore = useSessionStore()
  const signInEmail = ref("")
  const signInPassword = ref("")
  const signUpEmail = ref("")
  const signUpPassword = ref("")
  const signingIn = ref(true)
  const isHidden = ref(true)

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

  const toggleHidden = () => {
    isHidden.value = !isHidden.value
  }
</script>

<style lang="scss" scoped>
  #user-form {
    margin: 0 auto;
    width: 250px;
  }

  form {
    background-color: #242d36;
    border-radius: 0 0 10px 10px;
    box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.5);
    display: flex;
    flex-direction: column;
    overflow: hidden;

    button, input {
      color: inherit;
    }

    button {
      background-image: linear-gradient(135deg, #229968, #26634c);
      border: none;
      cursor: pointer;
      font-weight: 600;
      padding: 10px;
      text-shadow: 0 0 5px rgba(0, 0, 0, 0.5);
    }

    div {
      display: flex;
      flex-direction: column;
      gap: 5px;
      padding: 10px 0;
      text-align: left;
    }

    input, label {
      background-color: transparent;
      border: none;
      border-bottom: 1px solid transparent;
      margin: 0 1rem;
      padding: 0.5rem 0;
      transition: border-bottom 0.3s ease;

      &:focus {
        border-bottom: 1px solid #42b883aa;
        outline: none;
      }

      &:-webkit-autofill, &:-webkit-autofill:focus {
        transition: background-color 600000s 0s, color 600000s 0s;
      }
    }

    label {
      font-size: 0.8rem;
    }
  }

  h2 {
    background-image: linear-gradient(135deg, #2ce793aa, #328660aa);
    border-radius: 10px 10px 0 0;
    box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.5);
    padding: 15px;
    position: relative;
    text-shadow: 0 0 5px rgba(0, 0, 0, 0.5);
    z-index: 10;
  }

  p {
    font-size: 0.8rem;
    margin-top: 20px;
  }

  span {
    color: #42b883aa;
    cursor: pointer;
  }

  .password {
    align-items: center;
    flex-direction: row;
    justify-content: space-between;
    margin: 0 1rem;

    input {
      flex-grow: 1;
      margin: 0;
    }
  }
</style>
