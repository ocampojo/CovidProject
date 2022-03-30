-- Make sure data imported properly
SELECT *
FROM nashville_housing..NashvilleHousing


--Format SaleDate
SELECT Saledateconverted
FROM nashville_housing..NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing
add SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)


-- Populate Property Address Data
select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from nashville_housing..NashvilleHousing as a
JOIN nashville_housing..NashvilleHousing as b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] != b.[UniqueID ]
--where a.PropertyAddress is not null

update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From nashville_housing..NashvilleHousing as a
JOIN nashville_housing..NashvilleHousing as b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] != b.[UniqueID ]
where a.PropertyAddress is null


--Breaking out address into individual columns PropertyAddress(Address, City)
select *
from nashville_housing..NashvilleHousing

select SUBSTRING(PropertyAddress,1,charindex(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,charindex(',',PropertyAddress)+1, LEN(PropertyAddress)) as City
FROM nashville_housing..NashvilleHousing

Alter Table NashvilleHousing
add PropertySplitAddress Nvarchar(255)

update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress,1,charindex(',',PropertyAddress)-1)

Alter Table NashvilleHousing
add PropertySplitCity Nvarchar(255)

update NashvilleHousing
Set PropertySplitCity = Substring(PropertyAddress,charindex(',',PropertyAddress)+1, LEN(PropertyAddress))



--Breaking out address into individual columns OwnerAddress(Address, City,State)
select parsename(replace(owneraddress,',','.'),3),
parsename(replace(owneraddress,',','.'),2),
parsename(replace(owneraddress,',','.'),1)
from nashville_housing..NashvilleHousing

Alter Table NashvilleHousing
add OwnerSplitAddress Nvarchar(255),
OwnerSplitCity Nvarchar(255),
ownerSplitState Nvarchar(255)

update NashvilleHousing
Set OwnerSplitAddress = parsename(replace(owneraddress,',','.'),3),
OwnerSplitCity = parsename(replace(owneraddress,',','.'),2),
OwnerSplitState = parsename(replace(owneraddress,',','.'),1)


-- Change Y and N to Yes and No in "Sold as Vacant" field
select distinct(SoldAsVacant), count(SoldAsVacant)
from nashville_housing..NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant,
Case when SoldAsVacant = 'Y' Then 'Yes'
when SoldAsVacant = 'N' Then 'No'
Else SoldAsVacant
End
from nashville_housing..NashvilleHousing

update NashvilleHousing
set SoldAsVacant = Case when SoldAsVacant = 'Y' Then 'Yes'
when SoldAsVacant = 'N' Then 'No'
Else SoldAsVacant
End


--Remove Duplicates
with rownumCTE as(
select *,
ROW_NUMBER() over(Partition by parcelID, PropertyAddress, SalePrice, SaleDate, LegalReference Order by uniqueID) row_num
from nashville_housing..NashvilleHousing
--order by ParcelID
)
select *
from rownumCTE
where row_num > 1
--order by PropertyAddress


--Delete Unused Columns
select *
from nashville_housing..NashvilleHousing

alter table nashville_housing..nashvillehousing
drop column OwnerAddress, TaxDistrict, PropertyAddress

alter table nashville_housing..nashvillehousing
drop column SaleDate