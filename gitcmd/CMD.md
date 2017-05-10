# 查看git分支情况:  
	git log --graph --decorate --oneline --simplify-by-decoration --all  

# 常用命令:  
	1. git log origin/dusun_1505  
	2. git branch -t origin/dusun_1505  
	3. git checkout xxx  
	4. git log  
	5. git pull  
	6. git tag -l -n  
	7. git log -p -2  
	8. cp ./xxx.de_config ./.config  
	9. make -j1 V=16  

	10. git add  
	19. git commit  
	12. git push  

	13. git tag v3.7.7_tujia_fvt  
	14. ./release.sh v3.7.7_tujia  
	15. git push --tags  

	tower 上放入文件且写入跟新日志  
	16. ./uploadfw.sh v3.3.8_grl_test-0-gff55202_dsi0024/fw.bin  grl_new 格瑞利  
	17. ./uploadfw.sh  v3.4.0_grl_test_64MRam_8MFlash-0-g2365583_dsi0024/fw.bin  grl  

# 给package 打patch:  
        1. cd workdir  
        2. quilt new nnn.xxx.patch  
        3. quilt add a.c  
        4. cp a_old.c .  
        5. quilt diff  
        6. quilt refresh  
        7. cp nnn.xxx.patch patch_dir 

