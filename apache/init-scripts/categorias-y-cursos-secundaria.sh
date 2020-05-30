eso=$(moosh -n category-create -v 1 -r ESO)
bachillerato=$(moosh -n category-create -v 1 -r Bachillerato)
moosh -n category-create -v 1 -r FP
names_eso="Primero Segundo Tercero Cuarto"
names_bachillerato="Primero Segundo"

for name in $names_eso; do
  moosh -n category-create -p $eso -v 1 -r $name
done

for name in $names_bachillerato; do
  moosh -n category-create -p $bachillerato -v 1 -r $name
done