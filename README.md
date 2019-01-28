# node10-puppeteer

To use puppeteer in Docker container.

- OS: Alpine
- Language: Node.js 10

From
```
FROM matoba/node10-puppeteer
```

Fix puppeteer version in package.json
```
"puppeteer": "^1.9.0",
```

Launch puppeteer with some settings below
```
const chromePath = process.env.CHROME_BIN || null;  # CHROME_BIN has been already set in this Docker image
const browser = await puppeteer.launch({
  executablePath: chromePath,
  args: ['--no-sandbox', '--headless', '--disable-gpu']
});
```
