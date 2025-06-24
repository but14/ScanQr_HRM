import React, { useState } from 'react';
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
    scanTime: '2024-06-24T09:15:00'
  },
  {
    id: 2,
    name: 'Trần Thị B',
    cccd: '098765432109',
    dob: '1992-05-12',
    address: 'TP.HCM',
    scanTime: '2024-06-24T10:30:00'
  }
  // ... thêm dữ liệu thực tế ở đây
];

// ==============================|| DASHBOARD - DEFAULT ||============================== //

export default function DashboardDefault() {
  const [filterDate, setFilterDate] = useState('');

  // export excel
  const handleToExcel = () => {
    const ws = XLSX.utils.json_to_sheet(data);
    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, 'Danh sách quét mã QR');
    XLSX.writeFile(wb, 'Danh_sach_quet_ma_QR.xlsx');
  };

  // Lọc dữ liệu theo ngày
  const filteredData = filterDate ? data.filter((row) => row.scanTime.startsWith(filterDate)) : data;

  return (
    <MainCard title="Danh sách quét mã QR nhân sự">
      <Stack direction="row" spacing={2} alignItems="center" sx={{ mb: 2 }}>
        <Typography>Lọc theo ngày quét:</Typography>
        <TextField type="date" size="small" value={filterDate} onChange={(e) => setFilterDate(e.target.value)} />
      </Stack>
      <Button variant="contained" color="success" onClick={handleToExcel}>
        Xuất Excel
      </Button>
      <TableContainer component={Paper}>
        <Table>
          <TableHead>
            <TableRow>
              <TableCell>Họ tên</TableCell>
              <TableCell>Số CCCD</TableCell>
              <TableCell>Ngày sinh</TableCell>
              <TableCell>Địa chỉ</TableCell>
              <TableCell>Thời gian quét</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {filteredData.map((row) => (
              <TableRow key={row.id}>
                <TableCell>{row.name}</TableCell>
                <TableCell>{row.cccd}</TableCell>
                <TableCell>{row.dob}</TableCell>
                <TableCell>{row.address}</TableCell>
                <TableCell>{new Date(row.scanTime).toLocaleString()}</TableCell>
              </TableRow>
            ))}
            {filteredData.length === 0 && (
              <TableRow>
                <TableCell colSpan={5} align="center">
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
