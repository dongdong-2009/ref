# 查看git分支情况:  
	git cmd  * git log --graph --decorate --oneline --simplify-by-decoration --all  

# git log origin/dusun_1505  
	1. git branch -t origin/dusun_1505  
	2. git checkout xxx  
	3. git log  
	4. git pull  
	5. git tag -l -n  
	6. git log -p -2  
	7. cp ./xxx.de_config ./.config  
	8. make -j1 V=16  

	9. git add  
	10. git commit  
	11. git push  

	12. git tag v3.7.7_tujia_fvt  
	13. ./release.sh v3.7.7_tujia  
	14. git push --tags  

	tower 上放入文件且写入跟新日志  
	1. ./uploadfw.sh v3.3.8_grl_test-0-gff55202_dsi0024/fw.bin  grl_new 格瑞利  
	2. ./uploadfw.sh  v3.4.0_grl_test_64MRam_8MFlash-0-g2365583_dsi0024/fw.bin  grl  

# generate patch  
  1. cd workdir  
  2. quilt new nnn.xxx.patch  
  3. quilt add a.c  
  4. cp a_old.c .  
  5. quilt diff  
  6. quilt refresh  
  7. cp nnn.xxx.patch patch_dir 

