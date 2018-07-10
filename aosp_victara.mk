$(call inherit-product, device/motorola/victara/full_victara.mk)

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Overlay
DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay

TARGET_ARCH := arm
TARGET_GAPPS_ARCH := arm
TARGET_DENSITY := xxhdpi
TARGET_BOOT_ANIMATION_RES := 1080
PRODUCT_RELEASE_NAME := MOTO X (2014)
PRODUCT_NAME := aosp_victara
PRODUCT_MODEL := Moto X 2014

PRODUCT_GMS_CLIENTID_BASE := android-motorola
