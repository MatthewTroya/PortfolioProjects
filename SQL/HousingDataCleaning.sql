/* Show data */

Select *
from PortfolioProject..NashvilleHousing

-- Standardize date format

select saledate, saledateconverted
from PortfolioProject..NashvilleHousing

alter table NashvilleHousing
add SaleDateConverted Date;

Update NashvilleHousing
set SaleDateConverted = convert(date, saledate)

-- populate property address data

select *
from NashvilleHousing
where PropertyAddress is null

/* there are some duplicate parcelID which property address is the same so we can replace the null in some data */

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from NashvilleHousing a
join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-- breaking out address into individual columns (address, city, state)

select propertyaddress
from NashvilleHousing

	/* we can use the comma as a delimeter with the substring */

select
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) as Address,
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, len(PropertyAddress)) as City
from NashvilleHousing

alter table NashvilleHousing
add 
	PropertySplitAddress varchar(255),
	PropertySplitCity varchar(255);

update NashvilleHousing
set 
	PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1),
	PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, len(PropertyAddress));

	/* we can also use parsename */

select
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) as State,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) as City,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) as Address
from NashvilleHousing

alter table NashvilleHousing
add
	OwnerSplitAddress varchar(255),
	OwnerSplitCity varchar(255),
	OwnerSplitState varchar(255);

update NashvilleHousing
set
	OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
	OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
	OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);

-- change Y and N to Yes and No in "sold as vacant" field

select distinct(soldasvacant), count(soldasvacant)
from NashvilleHousing
group by SoldAsVacant

select soldasvacant,
	case when soldasvacant = 'Y' then 'Yes'
		 when soldasvacant = 'N' then 'No'
		 else soldasvacant
	end
from NashvilleHousing

update NashvilleHousing
set SoldAsVacant = case 
		when soldasvacant = 'Y' then 'Yes'
		when soldasvacant = 'N' then 'No'
		else soldasvacant
	end

