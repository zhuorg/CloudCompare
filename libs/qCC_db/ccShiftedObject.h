//##########################################################################
//#                                                                        #
//#                              CLOUDCOMPARE                              #
//#                                                                        #
//#  This program is free software; you can redistribute it and/or modify  #
//#  it under the terms of the GNU General Public License as published by  #
//#  the Free Software Foundation; version 2 or later of the License.      #
//#                                                                        #
//#  This program is distributed in the hope that it will be useful,       #
//#  but WITHOUT ANY WARRANTY; without even the implied warranty of        #
//#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the          #
//#  GNU General Public License for more details.                          #
//#                                                                        #
//#          COPYRIGHT: EDF R&D / TELECOM ParisTech (ENST-TSI)             #
//#                                                                        #
//##########################################################################

#ifndef CC_SHIFTED_INTERFACE_HEADER
#define CC_SHIFTED_INTERFACE_HEADER

//Local
#include "ccHObject.h"


//! Shifted entity interface
/** Shifted entities are entities which coordinates can be
	(optionally) shifted so as to reduce their amplitude and
	therefore display or accuracy issues.
**/
class QCC_DB_LIB_API ccShiftedObject : public ccHObject
{
public:

	//! Default constructor
	ccShiftedObject(QString name = QString());
	//! Copy constructor
	ccShiftedObject(const ccShiftedObject& s);

	//! Sets shift applied to original coordinates (information storage only)
	/** Such a shift can typically be applied at loading time.
	**/
	virtual void setCoordinatesShift(double x, double y, double z);

	//! Sets shift applied to original coordinates (information storage only)
	/** Such a shift can typically be applied at loading time.
		Original coordinates are equal to '(P/scale - shift)'
	**/
	virtual void setCoordinatesShift(const CCVector3d& shift);

	//! Returns the shift applied to original coordinates
	/** See ccGenericPointCloud::setOriginalShift
	**/
	const CCVector3d& getCoordinatesShift() const { return m_coordShift; }

	//! Sets the scale applied to original coordinates (information storage only)
	virtual void setCoordinatesScaleMultiplier(double scale);

	//! Returns the scale applied to original coordinates
	/** See ccGenericPointCloud::setOriginalScale
	**/
	inline double getCoordinatesScaleMultiplier() const { return m_coordScale; }

	//! Returns whether the entity is shifted or not
	inline bool isShifted() const
	{
		return (	m_coordShift.x != 0
				||	m_coordShift.y != 0
				||	m_coordShift.z != 0
				||	m_coordScale != 1.0 );
	}
	//! Returns the point back-projected into the original coordinates system
	template<typename T> inline CCVector3d toOriginalCoordinatesd(const Vector3Tpl<T>& PShifted) const
	{
		// Pglobal = Plocal/scale - shift
		return CCVector3d::fromArray(PShifted.u) / m_coordScale - m_coordShift;
	}

	//! Returns the point projected into the shifted coordinates system
	template<typename T> inline CCVector3d toShiftedCoordinatesd(const Vector3Tpl<T>& POriginalCoord) const
	{
		// Plocal = (Pglobal + shift) * scale
		return (CCVector3d::fromArray(POriginalCoord.u) + m_coordShift) * m_coordScale;
	}
	//! Returns the point projected into the shifted coordinates system
	template<typename T> inline CCVector3 toShiftedCoordinatespc(const Vector3Tpl<T>& POriginalCoord) const
	{
		CCVector3d Plocal = CCVector3d::fromArray(POriginalCoord.u) * m_coordScale + m_coordShift;
		return CCVector3::fromArray(Plocal.u);
	}

	//inherited from ccHObject
	virtual bool getGlobalBB(CCVector3d& minCorner, CCVector3d& maxCorner) override;

protected:

	//! Serialization helper (output)
	bool saveShiftInfoToFile(QFile& out) const;
	//! Serialization helper (input)
	bool loadShiftInfoFromFile(QFile& in);

	//! Global shift (typically applied at loading time)
	CCVector3d m_coordShift;

	//! Global scale (typically applied at loading time)
	double m_coordScale;

};

#endif //CC_SHIFTED_INTERFACE_HEADER
