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

#include "ccShiftedObject.h"

//local
#include "ccLog.h"
#include "ccSerializableObject.h"

ccShiftedObject::ccShiftedObject(QString name)
	: ccHObject(name)
	, m_coordShift(0,0,0)
	, m_coordScale(1.0)
{
}

ccShiftedObject::ccShiftedObject(const ccShiftedObject& s)
	: ccHObject(s)
	, m_coordShift(s.m_coordShift)
	, m_coordScale(s.m_coordScale)
{
}

void ccShiftedObject::setCoordinatesShift(const CCVector3d& shift)
{
	m_coordShift = shift;
}

void ccShiftedObject::setCoordinatesShift(double x, double y, double z)
{
	m_coordShift.x = x;
	m_coordShift.y = y;
	m_coordShift.z = z;
}

void ccShiftedObject::setCoordinatesScaleMultiplier(double scale)
{
	if (scale == 0)
	{
		ccLog::Warning("[setGlobalScale] Invalid scale (zero)!");
		m_coordScale = 1.0;
	}
	else
	{
		m_coordScale = scale;
	}
}

bool ccShiftedObject::saveShiftInfoToFile(QFile& out) const
{
	//'coordinates shift'
	if (out.write((const char*)m_coordShift.u,sizeof(double)*3) < 0)
		return ccSerializableObject::WriteError();
	//'global scale'
	if (out.write((const char*)&m_coordScale,sizeof(double)) < 0)
		return ccSerializableObject::WriteError();

	return true;
}

bool ccShiftedObject::loadShiftInfoFromFile(QFile& in)
{
	//'coordinates shift'
	if (in.read((char*)m_coordShift.u,sizeof(double)*3) < 0)
		return ccSerializableObject::ReadError();
	//'global scale'
	if (in.read((char*)&m_coordScale,sizeof(double)) < 0)
		return ccSerializableObject::ReadError();

	return true;
}

bool ccShiftedObject::getGlobalBB(CCVector3d& minCorner, CCVector3d& maxCorner)
{
	ccBBox box = getOwnBB(false);
	minCorner = toOriginalCoordinatesd(box.minCorner());
	maxCorner = toOriginalCoordinatesd(box.maxCorner());
	return box.isValid();
}
