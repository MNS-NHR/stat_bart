3dresample -input Heatmaps_peri2.nii -prefix heatmaps_rs.nii.gz -dxyz 4 4 4

#

#3dresample -inset Heatmaps_peri32.nii -prefix heatmaps_rs.nii.gz -dxyz 100 100 100

fslchpixdim heatmaps_rs.nii.gz 100 100 100
fslorient -setsform 100 0 0 0 0 100 0 0 0 0 100 0 0 0 0 1 heatmaps_rs.nii.gz 
fslorient -setqform 100 0 0 0 0 100 0 0 0 0 100 0 0 0 0 1 heatmaps_rs.nii.gz 

fslorient -deleteorient heatmaps_rs.nii.gz 

3dBlurInMask -input heatmaps_rs.nii.gz -FWHM 200 -mask mask_R.nii.gz -prefix heatmaps_rs_smooth.nii.gz
fslorient -deleteorient heatmaps_rs_smooth.nii.gz 

fslmaths heatmaps_rs_smooth.nii.gz -bin -Tmean -thr 1 -bin mask_corr.nii.gz

fsl_glm -i heatmaps_rs_smooth.nii.gz -o glm_beta --out_z=glm_z --out_res=glm_res -m mask_corr.nii.gz -d design.mat -c design.con

easythresh glm_z.nii.gz mask_corr.nii.gz 2.3 0.05 mask_corr.nii.gz easy005
