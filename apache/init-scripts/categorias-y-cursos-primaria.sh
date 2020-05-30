infantil=$(moosh -n category-create -v 1 -r Infantil)
primaria=$(moosh -n category-create -v 1 -r Primaria)
moosh -n category-create -v 1 -r Saladeprofes
names_infantil="Primero Segundo Tercero"
names_primaria="Primero Segundo Tercero Cuarto Quinto Sexto"

for name in $names_infantil; do
  moosh -n category-create -p $infantil -v 1 -r $name
done

for name in $names_primaria; do
  moosh -n category-create -p $primaria -v 1 -r $name
done