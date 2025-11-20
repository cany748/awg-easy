export default defineNitroPlugin((nitroApp) => {
  console.warn(`==========!!!STOP USING THIS CONTAINER!!!===========`);
  console.warn(
    `All changes from this fork have been merged into the original repository.`
  );
  console.warn(
    `The migration will happen automatically, just change the docker image to ghcr.io/wg-easy/wg-easy 15.2.0-beta.2 or later.`
  );
  console.warn(`==========!!!STOP USING THIS CONTAINER!!!===========`);
  nitroApp.hooks.hook('close', async () => {
    console.log('Shutting down');
    await WireGuard.Shutdown();
  });
});
