import init, { greet, add } from './hello.nim';

async function main() {
  await init();
  const result = greet('from Vite');
  console.log(result);
  document.getElementById('app').innerHTML = `<h1>${result}</h1><p>3 + 4 = ${add(3, 4)}</p>`;
}

main().catch(console.error);
