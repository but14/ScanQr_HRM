import React, { useEffect, useState } from 'react';
// material-ui
import Avatar from '@mui/material/Avatar';
import AvatarGroup from '@mui/material/AvatarGroup';
import Button from '@mui/material/Button';
import Grid from '@mui/material/Grid2';
import List from '@mui/material/List';
import ListItem from '@mui/material/ListItem';
import ListItemAvatar from '@mui/material/ListItemAvatar';
import ListItemButton from '@mui/material/ListItemButton';
import ListItemText from '@mui/material/ListItemText';
import Stack from '@mui/material/Stack';
import Typography from '@mui/material/Typography';
import Box from '@mui/material/Box';

// Excel
import * as XLSX from 'xlsx';

import TextField from '@mui/material/TextField';
import Table from '@mui/material/Table';
import TableBody from '@mui/material/TableBody';
import TableCell from '@mui/material/TableCell';
import TableContainer from '@mui/material/TableContainer';
import TableHead from '@mui/material/TableHead';
import TableRow from '@mui/material/TableRow';
import Paper from '@mui/material/Paper';

// project imports
import MainCard from 'components/MainCard';
import AnalyticEcommerce from 'components/cards/statistics/AnalyticEcommerce';
import MonthlyBarChart from 'sections/dashboard/default/MonthlyBarChart';
import ReportAreaChart from 'sections/dashboard/default/ReportAreaChart';
import UniqueVisitorCard from 'sections/dashboard/default/UniqueVisitorCard';
import SaleReportCard from 'sections/dashboard/default/SaleReportCard';
import OrdersTable from 'sections/dashboard/default/OrdersTable';

// assets
import GiftOutlined from '@ant-design/icons/GiftOutlined';
import MessageOutlined from '@ant-design/icons/MessageOutlined';
import SettingOutlined from '@ant-design/icons/SettingOutlined';

// avatar style
const avatarSX = {
  width: 36,
  height: 36,
  fontSize: '1rem'
};

// action style
const actionSX = {
  mt: 0.75,
  ml: 1,
  top: 'auto',
  right: 'auto',
  alignSelf: 'flex-start',
  transform: 'none'
};

// Dummy data mẫu
const data = [
  {
    id: 1,
    name: 'Nguyễn Văn A',
    cccd: '012345678901',
    dob: '1990-01-01',
    address: 'Hà Nội',
    scanTime: '2024-06-24T09:15:00',
    factory: 'Nhà máy A'
  },
  {
    id: 2,
    name: 'Trần Thị B',
    cccd: '098765432109',
    dob: '1992-05-12',
    address: 'TP.HCM',
    scanTime: '2024-06-24T10:30:00',
    factory: 'Nhà máy B'
  }
  // ... thêm dữ liệu thực tế ở đây
];

// ==============================|| DASHBOARD - DEFAULT ||============================== //

export default function DashboardDefault() {
  const [filterDate, setFilterDate] = useState('');
  const [data, setData] = useState([]);

  useEffect(() => {
    const user = JSON.parse(localStorage.getItem('user'));
    if (!user?.id) {
      setData([]);
      return;
    }
    fetch(`http://localhost:5000/api/scan/employees-by-manager?manager_id=${user.id}`)
      .then((res) => res.json())
      .then((res) => setData(res.employees || []))
      .catch((err) => {
        setData([]);
        console.error('Lỗi lấy dữ liệu:', err);
      });
  }, []);

  const handleToExcel = () => {
    // Chỉ lấy các trường hiển thị trên bảng
    const exportData = filteredData.map((row) => ({
      'Họ tên': row.full_name,
      'Số CCCD': row.id_number,
      'Ngày sinh': row.date_of_birth ? row.date_of_birth.slice(0, 10) : '',
      'Địa chỉ': row.place_of_residence,
      'Nhà máy': row.factory || '',
      'Thời gian quét': row.created_at ? new Date(row.created_at).toLocaleString() : ''
    }));
    const ws = XLSX.utils.json_to_sheet(exportData);
    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, 'Danh sách quét mã QR');
    XLSX.writeFile(wb, 'Danh_sach_quet_ma_QR.xlsx');
  };

  const filteredData = filterDate ? data.filter((row) => row.created_at?.startsWith(filterDate)) : data;

  return (
    <MainCard
      sx={{ height: '90vh', display: 'flex', flexDirection: 'column' }} // Thêm dòng này
      title={
        <Typography variant="h4" fontWeight="bold">
          Danh sách nhân sự
        </Typography>
      }
    >
      <Stack direction="row" spacing={2} alignItems="center" sx={{ mb: 2 }}>
        <Typography>Lọc theo ngày:</Typography>
        <TextField type="date" size="small" value={filterDate} onChange={(e) => setFilterDate(e.target.value)} />
      </Stack>
      <Button variant="contained" color="success" onClick={handleToExcel} sx={{ mb: 2 }}>
        Xuất Excel
      </Button>
      <TableContainer
        component={Paper}
        sx={{
          flex: 1,
          minHeight: 0,
          maxHeight: '100%',
          overflowY: 'auto'
        }}
      >
        <Table stickyHeader>
          <TableHead>
            <TableRow>
              <TableCell>Họ tên</TableCell>
              <TableCell>Số CCCD</TableCell>
              <TableCell>Ngày sinh</TableCell>
              <TableCell>Địa chỉ</TableCell>
              <TableCell>Nhà máy</TableCell>
              <TableCell>Thời gian quét</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {filteredData.map((row) => (
              <TableRow key={row.id}>
                <TableCell>{row.full_name}</TableCell>
                <TableCell>{row.id_number}</TableCell>
                <TableCell>{row.date_of_birth ? row.date_of_birth.slice(0, 10) : ''}</TableCell>
                <TableCell>{row.place_of_residence}</TableCell>
                <TableCell>{row.factory || ''}</TableCell>
                <TableCell>{row.created_at ? new Date(row.created_at).toLocaleString() : ''}</TableCell>
              </TableRow>
            ))}
            {filteredData.length === 0 && (
              <TableRow>
                <TableCell colSpan={6} align="center">
                  Không có dữ liệu
                </TableCell>
              </TableRow>
            )}
          </TableBody>
        </Table>
      </TableContainer>
    </MainCard>
  );
}
