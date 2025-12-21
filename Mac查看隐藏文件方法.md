# 🖥️ Mac 查看隐藏文件的方法

## 方法一：使用快捷键（最简单，推荐⭐⭐⭐）

### 在 Finder 中：
1. 打开 Finder
2. 按快捷键：**`Command + Shift + .`**（Command + Shift + 句号）
3. 隐藏文件会显示出来（半透明显示）
4. 再次按相同快捷键可以隐藏

**优点**：最快最简单，不需要任何设置

---

## 方法二：使用终端命令

### 显示隐藏文件：
```bash
defaults write com.apple.finder AppleShowAllFiles -bool true
killall Finder
```

### 隐藏文件：
```bash
defaults write com.apple.finder AppleShowAllFiles -bool false
killall Finder
```

**注意**：执行后需要重启 Finder（会自动重启）

---

## 方法三：在终端中直接查看

```bash
# 查看当前目录所有文件（包括隐藏文件）
ls -la

# 查看特定目录
ls -la "/Users/franklin/Downloads/路由插件/想"
```

---

## 📋 针对您的项目

### 查看 `.github` 文件夹：

**方法 1：Finder**
1. 打开 Finder
2. 导航到：`/Users/franklin/Downloads/路由插件/想`
3. 按 `Command + Shift + .`
4. `.github` 文件夹会显示出来（半透明）

**方法 2：终端**
```bash
cd "/Users/franklin/Downloads/路由插件/想"
ls -la
# 会显示所有文件，包括 .github
```

---

## 💡 快速操作

### 在 Finder 中查看 `.github` 文件夹：

1. **打开 Finder**
2. **按 `Command + Shift + G`**（前往文件夹）
3. **输入路径**：`/Users/franklin/Downloads/路由插件/想`
4. **按 Enter**
5. **按 `Command + Shift + .`**（显示隐藏文件）
6. **找到 `.github` 文件夹**（半透明显示）

---

## 🎯 推荐方法

**最推荐使用方法一（快捷键）**：
- ✅ 最简单
- ✅ 不需要重启
- ✅ 可以随时切换显示/隐藏
- ✅ 不需要终端

---

## 📝 提示

- 隐藏文件通常以 `.` 开头（如 `.github`、`.git`）
- 在 Finder 中，隐藏文件会以**半透明**方式显示
- 快捷键 `Command + Shift + .` 可以反复切换显示/隐藏

---

现在试试按 `Command + Shift + .` 吧！🚀
