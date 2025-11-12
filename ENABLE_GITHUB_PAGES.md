# How to Enable GitHub Pages

Your documentation site is ready! Follow these steps to publish it at:
**https://omar-karray.github.io/HoaLibrary-Max/**

## Steps to Enable

1. **Go to your GitHub repository**
   - Navigate to: https://github.com/omar-karray/HoaLibrary-Max

2. **Open Settings**
   - Click the "Settings" tab (top right)

3. **Go to Pages Section**
   - In the left sidebar, click "Pages" (under "Code and automation")

4. **Configure Source**
   - **Source**: Select "Deploy from a branch"
   - **Branch**: Select `master` (or `main`)
   - **Folder**: Select `/docs`
   - Click "Save"

5. **Wait for Deployment**
   - GitHub will automatically build and deploy your site
   - This takes 1-2 minutes
   - You'll see a green checkmark when ready

6. **Visit Your Site**
   - Go to: https://omar-karray.github.io/HoaLibrary-Max/
   - Bookmark it and share with users!

## What You Get

Your professional documentation site includes:

### 📚 Complete Guides
- **Getting Started** - 30-minute hands-on tutorial
- **What is HOA?** - Deep dive into ambisonics theory
- **Installation** - Step-by-step setup guide
- **Tutorials** - Guide to 10 built-in interactive patches
- **Practical Examples** - 10 ready-to-use Max patches
- **Object Reference** - All 37 externals documented
- **Academic References** - Papers, institutions, citations

### 🎨 Professional Design
- Card-based navigation
- Highlighted "Getting Started" section
- Responsive layout
- Clean typography
- Easy navigation

### 🔗 SEO Optimized
- Proper meta tags
- GitHub badges
- Structured content
- Clear navigation

## Troubleshooting

### Site Not Showing?
- Wait 2-3 minutes after enabling
- Check Settings → Pages for green checkmark
- Verify branch is `master` and folder is `/docs`
- Try accessing in incognito mode (cache issue)

### 404 Error?
- Make sure `docs/` folder exists in master branch
- Check that `docs/index.md` exists
- Verify `docs/_config.yml` is present

### Styling Issues?
- Check `docs/assets/css/style.scss` exists
- Verify `docs/_layouts/default.html` is present
- Wait for rebuild (can take a few minutes)

## Updating the Site

Whenever you update documentation:

```bash
# Edit files in docs/
git add docs/
git commit -m "docs: Update documentation"
git push origin master
```

GitHub Pages will automatically rebuild (1-2 minutes).

## Custom Domain (Optional)

Want to use your own domain like `docs.hoalibrary.com`?

1. Settings → Pages → Custom domain
2. Enter your domain
3. Add DNS records at your domain provider:
   - Type: CNAME
   - Name: docs (or www)
   - Value: omar-karray.github.io

## Analytics (Optional)

Add Google Analytics to track visitors:

1. Get your GA tracking ID
2. Edit `docs/_config.yml`
3. Add:
   ```yaml
   google_analytics: UA-XXXXXXXXX-X
   ```

---

## 🎉 That's It!

Your professional documentation site is live!

**Site URL**: https://omar-karray.github.io/HoaLibrary-Max/

Share it with:
- Max users and communities
- Academic researchers
- Game developers
- Music producers
- Installation artists

The site showcases HoaLibrary v3.0 with complete guides, examples, and references!
