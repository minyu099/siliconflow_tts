@echo off
chcp 65001 >nul
cd /d "%~dp0"

echo ========================================
echo    SiliconFlow TTS Studio 便携启动器
echo ========================================
echo.

:: 检查Python
python --version >nul 2>&1
if errorlevel 1 (
    echo [错误] 未检测到 Python 环境
    echo.
    echo 请先安装 Python 3.8 或更高版本
    echo 下载地址: https://www.python.org/downloads/
    echo.
    echo 安装时请勾选 "Add Python to PATH"
    pause
    exit /b 1
)

for /f "tokens=*" %%i in ('python --version 2^>^&1') do set PYTHON_VERSION=%%i
echo [OK] 检测到 %PYTHON_VERSION%

:: 检查依赖
echo.
echo [提示] 正在检查并安装依赖包...
pip install -r requirements.txt -q
if errorlevel 1 (
    echo.
    echo [警告] 依赖安装出现问题，尝试重新安装...
    pip install -r requirements.txt
    if errorlevel 1 (
        echo [错误] 依赖安装失败
        pause
        exit /b 1
    )
)
echo [OK] 依赖安装完成

:: 检查.env配置
if not exist ".env" (
    echo.
    echo [重要] 首次使用需要配置 API Key
    echo.
    echo 请访问 https://cloud.siliconflow.cn 注册账号
    echo 然后获取 API Key 并创建 .env 文件
    echo.
    echo 或者直接在同一目录下创建 .env 文件，内容如下:
    echo    SILICONFLOW_API_KEY=你的API密钥
    echo.
    echo 示例:
    echo    SILICONFLOW_API_KEY=sk-xxxxxxxxxxxx
    echo.
    echo 配置完成后，请重新运行此启动器
    pause
    exit /b 1
)

:: 检查API Key是否有效
findstr /C "SILICONFLOW_API_KEY=sk-your_key_here" .env >nul 2>&1
if not errorlevel 1 (
    echo.
    echo [重要] 请先配置有效的 API Key
    echo.
    echo 1. 访问 https://cloud.siliconflow.cn 注册/登录
    echo 2. 获取 API Key
    echo 3. 编辑 .env 文件，将 sk-your_key_here 替换为你的真实API Key
    echo.
    pause
    exit /b 1
)

echo [OK] API Key 配置检查通过
echo.
echo ========================================
echo    正在启动服务...
echo ========================================
echo.
echo 服务地址: http://127.0.0.1:8000
echo 按 Ctrl+C 可停止服务
echo.
echo 浏览器将自动打开...

:: 启动浏览器
timeout /t 2 /nobreak >nul
start http://127.0.0.1:8000

:: 启动服务
python launcher.py

pause
