$(call inherit-product, device/motorola/victara/full_victara.mk)

# Inherit some common Carbon stuff.
$(call inherit-product, vendor/carbon/config/cdma.mk)
$(call inherit-product, vendor/carbon/config/common.mk)

# Overlay
DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay

PRODUCT_RELEASE_NAME := MOTO X (2014)
PRODUCT_NAME := carbon_victara
PRODUCT_MODEL := Moto X 2014

PRODUCT_GMS_CLIENTID_BASE := android-motorola
