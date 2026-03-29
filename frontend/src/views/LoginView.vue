<template>
  <div class="login-wrap">
    <div class="login-card">
      <div class="brand">MiroFish</div>
      <p class="subtitle">Enter access password to continue</p>
      <form @submit.prevent="submit">
        <input
          v-model="password"
          type="password"
          placeholder="Password"
          class="password-input"
          autofocus
          :disabled="loading"
        />
        <p v-if="error" class="error-msg">{{ error }}</p>
        <button type="submit" class="submit-btn" :disabled="loading || !password">
          {{ loading ? 'Verifying…' : 'Enter' }}
        </button>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import service from '../api/index.js'

const router = useRouter()
const password = ref('')
const error = ref('')
const loading = ref(false)

async function submit() {
  error.value = ''
  loading.value = true
  try {
    await service.post('/api/auth/verify', { password: password.value })
    sessionStorage.setItem('access_key', password.value)
    router.push('/')
  } catch (e) {
    error.value = 'Incorrect password'
    password.value = ''
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.login-wrap {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #0d0d0d;
}

.login-card {
  width: 340px;
  padding: 40px 36px;
  background: #111;
  border: 1px solid #2a2a2a;
  border-radius: 8px;
}

.brand {
  font-family: 'JetBrains Mono', monospace;
  font-size: 22px;
  font-weight: 700;
  color: #e8e8e8;
  margin-bottom: 6px;
  letter-spacing: -0.5px;
}

.subtitle {
  font-family: 'Space Grotesk', sans-serif;
  font-size: 13px;
  color: #555;
  margin: 0 0 28px;
}

.password-input {
  width: 100%;
  padding: 10px 12px;
  background: #1a1a1a;
  border: 1px solid #2a2a2a;
  border-radius: 5px;
  color: #e8e8e8;
  font-family: 'JetBrains Mono', monospace;
  font-size: 14px;
  outline: none;
  box-sizing: border-box;
  transition: border-color 0.15s;
}

.password-input:focus {
  border-color: #444;
}

.password-input:disabled {
  opacity: 0.5;
}

.error-msg {
  font-family: 'Space Grotesk', sans-serif;
  font-size: 12px;
  color: #e05c5c;
  margin: 8px 0 0;
}

.submit-btn {
  width: 100%;
  margin-top: 16px;
  padding: 10px;
  background: #e8e8e8;
  color: #0d0d0d;
  border: none;
  border-radius: 5px;
  font-family: 'Space Grotesk', sans-serif;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: opacity 0.15s;
}

.submit-btn:disabled {
  opacity: 0.35;
  cursor: not-allowed;
}

.submit-btn:not(:disabled):hover {
  opacity: 0.85;
}
</style>
