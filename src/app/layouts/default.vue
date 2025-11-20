<template>
  <div>
    <header class="mx-auto mt-4 flex max-w-3xl flex-col justify-center">
      <div
        class="mb-5 w-full"
        :class="
          loggedIn
            ? 'flex flex-col items-center justify-between sm:flex-row'
            : 'flex justify-end'
        "
      >
        <HeaderLogo v-if="loggedIn" />
        <div class="flex flex-row gap-3">
          <HeaderLangSelector />
          <HeaderThemeSwitch />
          <HeaderChartToggle v-if="loggedIn" />
          <UiUserMenu v-if="loggedIn" />
        </div>
      </div>
      <HeaderUpdate class="mt-4" />
    </header>
    <div
      v-if="loggedIn"
      class="mx-auto my-4 max-w-3xl rounded-md bg-red-600 p-4 text-center font-bold text-white"
    >
      <div class="text-xl">
        This container is deprecated, please do not use it anymore.
      </div>
      <div class="mt-3">
        All changes from this fork have been merged into the
        <a href="https://github.com/wg-easy/wg-easy/" class="underline"
          >original repository</a
        >
        .
      </div>
      <div class="mt-3">
        The migration will happen automatically, just change the docker image to
        <pre>ghcr.io/wg-easy/wg-easy</pre>
        <span class="underline">15.2.0-beta.2 or later</span>.
      </div>
    </div>
    <slot />
    <UiFooter />
  </div>
</template>

<script setup lang="ts">
const route = useRoute();

const loggedIn = computed(() => route.path !== '/login');
</script>
