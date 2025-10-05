export default defineNitroPlugin((nitroApp) => {
  console.log(`====================================================`);
  console.log(`    awg-easy - https://github.com/evoll/awg-easy    `);
  console.log(`====================================================`);
  console.log(`| awg-easy:  ${RELEASE.padEnd(38)} |`);
  console.log(`| Node:     ${process.version.padEnd(38)} |`);
  console.log(`| Platform: ${process.platform.padEnd(38)} |`);
  console.log(`| Arch:     ${process.arch.padEnd(38)} |`);
  console.log(`====================================================`);
  nitroApp.hooks.hook('close', async () => {
    console.log('Shutting down');
    await WireGuard.Shutdown();
  });
});
