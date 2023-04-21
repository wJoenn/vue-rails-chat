<template>
  <div id="home">
    <div>
      <a href="https://vitejs.dev" target="_blank">
        <img src="../assets/images/vite.svg" class="logo" alt="Vite logo">
      </a>

      <a href="https://vuejs.org/" target="_blank">
        <img src="../assets/images/vue.svg" class="logo vue" alt="Vue logo">
      </a>
    </div>

    <HelloWorld msg="Vite + Vue" />
  </div>
</template>

<script setup>
  import HelloWorld from "../components/HelloWorld.vue"
</script>

<style lang="scss" scoped>
  .logo {
    height: 6em;
    padding: 1.5em;
    transition: filter 0.3s ease;

    &:hover {
      filter: drop-shadow(0 0 2em #646cffaa);
    }

    &.vue:hover {
      filter: drop-shadow(0 0 2em #42b883aa);
    }
  }
</style>
