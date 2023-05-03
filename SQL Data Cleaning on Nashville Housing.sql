
Select *
From PortfolioProject..NashvilleHousing

-- Converting the Date Format:

Update NashvilleHousing
Set SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted = CONVERT(Date, SaleDate)

Select SaleDateConverted
from PortfolioProject..NashvilleHousing

-- Rectify the null values in the Proprty Address columns.

Select * 
From PortfolioProject..NashvilleHousing
Where PropertyAddress is null

Select * 
From PortfolioProject..NashvilleHousing
-- where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]

Update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]

-- Separating the address into separate columns.

Select PropertyAddress
From PortfolioProject..NashvilleHousing

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1),
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))
From PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertyLocation Nvarchar(255)

Update NashvilleHousing
Set PropertyLocation = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing
Add PropertyCity Nvarchar(255)

Update NashvilleHousing
Set PropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

Select *
From PortfolioProject..NashvilleHousing



Select
PARSENAME(REPLACE(OwnerAddress, ',','.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',','.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)
From PortfolioProject..NashvilleHousing


ALTER TABLE NashvilleHousing
Add OwnerLocation Nvarchar(255)

Update NashvilleHousing
Set OwnerLocation = PARSENAME(REPLACE(OwnerAddress, ',','.'), 3)

ALTER TABLE NashvilleHousing
Add OwnerCity Nvarchar(255)

Update NashvilleHousing
Set OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',','.'), 2)

ALTER TABLE NashvilleHousing
Add OwnerState Nvarchar(255)

Update NashvilleHousing
Set OwnerState = PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)

Select *
From PortfolioProject..NashvilleHousing


-- Rectifying the SoldAsVacant column. Changing the 'Y' to 'Yes' & 'N' to 'No'.

Select Distinct(SoldAsVacant) 
From PortfolioProject..NashvilleHousing

Select SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
From PortfolioProject..NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END

Select Distinct(SoldAsVacant), count(SoldAsVacant)
From PortfolioProject..NashvilleHousing
Group by SoldAsVacant


-- Removing duplicate columns.

With RowNumCTE As(
Select *,
	ROW_NUMBER() OVER (
	Partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order by
					UniqueID
					) row_num

From PortfolioProject..NashvilleHousing
)

--DELETE
--from RowNumCTE
--Where row_num > 1

Select *
from RowNumCTE
Where row_num > 1


-- Delete unused columns.

Select *
From PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN	OwnerAddress, TaxDistrict, PropertyAddress 