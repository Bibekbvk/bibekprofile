@echo off
echo ====================================================
echo   Building Bibek Bhattarai Web Release for Deployment
echo ====================================================

echo [1/3] Compiling production Flutter Web bundle...
call flutter build web --release

echo [2/3] Updating Desktop deploy folder...
python -c "import shutil, os; src='build/web'; dst=r'c:\Users\Asus\Desktop\Bibek_Website_Deploy'; shutil.rmtree(dst, ignore_errors=True); shutil.copytree(src, dst); bid=os.path.join(dst, '.last_build_id'); os.remove(bid) if os.path.exists(bid) else None"

echo [3/3] Deployment package ready at:
echo       c:\Users\Asus\Desktop\Bibek_Website_Deploy
echo.
echo ====================================================
echo   Success! Drag c:\Users\Asus\Desktop\Bibek_Website_Deploy 
echo   to Cloudflare Pages to update your live site instantly!
echo ====================================================
pause
