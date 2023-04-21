<template>
  <h1>{{ msg }}</h1>

  <div class="card">
    <button type="button" @click="count++">count is {{ count }}</button>
    <p>Edit <code>components/HelloWorld.vue</code> to test HMR</p>
  </div>

  <p>Check out <a href="https://vuejs.org/guide/quick-start.html#local" target="_blank">create-vue</a>, the official Vue + Vite starter</p>

  <p>Install <a href="https://github.com/vuejs/language-tools" target="_blank">Volar</a> in your IDE for a better DX</p>

  <p class="read-the-docs">Click on the Vite and Vue logos to learn more</p>
</template>

<script setup>
  import { ref } from "vue"

  defineProps({
    msg: String
  })

  const count = ref(0)
</script>

<style lang="scss" scoped>
  button {
    border-radius: 10px;
    border: 1px solid transparent;
    color: inherit;
    padding: 0.5em 1em;
    font-size: 1em;
    font-weight: 500;
    font-family: inherit;
    background-color: #181a1b;
    cursor: pointer;
    transition: border-color 0.3s ease;

    &:hover {
      border-color: #42b883;
    }
  }

  h1 {
    font-size: 3.2em;
    line-height: 1.1;
  }

  .card {
    padding: 2em;
  }

  .read-the-docs {
    color: #888;
  }
</style>
