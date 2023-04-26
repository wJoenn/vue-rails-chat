<template>
  <div class="chat">
    <div v-for="chatroom in chatrooms" :key="chatroom.id">
      {{ chatroom.name }}
    </div>
  </div>
</template>

<script setup>
  import { ref } from "vue"

  const chatrooms = ref([])

  const backendUrl = import.meta.env.VITE_BACKEND_URL
  const url = `${backendUrl}/chatrooms`
  fetch(url, {
    headers: { Authorization: localStorage.getItem("authToken") }
  }).then(res => res.json())
    .then(data => {
      chatrooms.value = data
    })
</script>

<style lang="scss" scoped>

</style>
